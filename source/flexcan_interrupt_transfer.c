/*
 * Copyright (c) 2015, Freescale Semiconductor, Inc.
 * Copyright 2016-2019 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "fsl_debug_console.h"
#include "fsl_flexcan.h"
#include "board.h"

#include "fsl_device_registers.h"
#include "fsl_common.h"
#include "pin_mux.h"
#include "clock_config.h"

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h"
#include "semphr.h"
#include "queue.h"

/* The software timer period. */
#define SW_TIMER_PERIOD_MS (1000 / portTICK_PERIOD_MS) /* Timer */
/*******************************************************************************
 * Prototypes
 ******************************************************************************/
/* The callback function. */
static void SwTimerCallback(TimerHandle_t xTimer); /* Timer */

static void producer_task(void *pvParameters);  /* Task */
static void consumer_task(void *pvParameters);  /* Task */

/*******************************************************************************
 * Definitions
 ******************************************************************************/
#define EXAMPLE_CAN CAN0
#define EXAMPLE_CAN_CLKSRC kCLOCK_BusClk
#define EXAMPLE_CAN_CLK_FREQ CLOCK_GetFreq(kCLOCK_BusClk)
#define RX_MESSAGE_BUFFER_NUM (9)
#define TX_MESSAGE_BUFFER_NUM (8)
#define USE_CANFD (1)
#define USE_IMPROVED_TIMING_CONFIG (1)

#define TASK_PRIO (configMAX_PRIORITIES - 1)	/* Task */
#define CONSUMER_LINE_SIZE 3					/* Task */
SemaphoreHandle_t xSemaphore_producer;			/* Task */
SemaphoreHandle_t xSemaphore_consumer;			/* Task */

/*
 *    DWORD_IN_MB    DLC    BYTES_IN_MB             Maximum MBs
 *    2              8      kFLEXCAN_8BperMB        32
 *    4              10     kFLEXCAN_16BperMB       21
 *    8              13     kFLEXCAN_32BperMB       12
 *    16             15     kFLEXCAN_64BperMB       7
 *
 * Dword in each message buffer, Length of data in bytes, Payload size must align,
 * and the Message Buffers are limited corresponding to each payload configuration:
 */
#define DWORD_IN_MB (4)
#define DLC (10)
#define BYTES_IN_MB kFLEXCAN_16BperMB

/* To get most precise baud rate under some circumstances, users need to set
   quantum which is composed of PSEG1/PSEG2/PROPSEG. Because CAN clock prescaler
   = source clock/(baud rate * quantum), for e.g. 84M clock and 1M baud rate, the
   quantum should be .e.g 14=(6+3+1)+4, so prescaler is 6. By default, quantum
   is set to 10=(3+2+1)+4, because for most platforms e.g. 120M source clock/(1M
   baud rate * 10) is an integer. Remember users must ensure the calculated
   prescaler an integer thus to get precise baud rate. */
#define SET_CAN_QUANTUM 0
#define PSEG1 3
#define PSEG2 2
#define PROPSEG 1
#define FPSEG1 3
#define FPSEG2 3
#define FPROPSEG 1
#if (defined(FSL_FEATURE_FLEXCAN_HAS_ERRATA_5829) && FSL_FEATURE_FLEXCAN_HAS_ERRATA_5829)
/* To consider the First valid MB must be used as Reserved TX MB for ERR005829
   If RX FIFO enable(RFEN bit in MCE set as 1) and RFFN in CTRL2 is set default zero, the first valid TX MB Number is 8
   If RX FIFO enable(RFEN bit in MCE set as 1) and RFFN in CTRL2 is set by other value(0x1~0xF), User should consider
   detail first valid MB number
   If RX FIFO disable(RFEN bit in MCE set as 0) , the first valid MB number is zero */
#ifdef RX_MESSAGE_BUFFER_NUM
#undef RX_MESSAGE_BUFFER_NUM
#define RX_MESSAGE_BUFFER_NUM (10)
#endif
#ifdef TX_MESSAGE_BUFFER_NUM
#undef TX_MESSAGE_BUFFER_NUM
#define TX_MESSAGE_BUFFER_NUM (9)
#endif
#endif
#ifndef DEMO_FORCE_CAN_SRC_OSC
#define DEMO_FORCE_CAN_SRC_OSC 0
#endif
/*******************************************************************************
 * Prototypes
 ******************************************************************************/
static void producer_task(void *pvParameters);		/* Task */
static void consumer_task(void *pvParameters);		/* Task */

/*******************************************************************************
 * Variables
 ******************************************************************************/
flexcan_handle_t flexcanHandle;
volatile bool txComplete = false;
volatile bool rxComplete = false;
volatile bool wakenUp    = false;
flexcan_mb_transfer_t txXfer, rxXfer;
#if (defined(USE_CANFD) && USE_CANFD)
flexcan_fd_frame_t frame;
#else
flexcan_frame_t frame;
#endif
uint32_t txIdentifier;
uint32_t rxIdentifier;

uint32_t baudRates[] = {250000U, 500000U, 1000000U};
uint8_t PIDs[] = {0x00,0x01,0x03,0x04,0x05,0x0A,0x0C,0x0D,0x0F,0x11};

flexcan_config_t flexcanConfig;
flexcan_rx_mb_config_t mbConfig;
uint8_t node_type;

bool watch_dog = false;

typedef struct{
	uint32_t id_found;
	uint32_t timestamp;
	uint8_t  Byte0;
	uint8_t  Byte1;
	uint8_t  Byte2;
	uint8_t  Byte3;
}IDs_datas;

IDs_datas Found_ID[20][20];

/*******************************************************************************
 * My functions
 * ****************************************************************************/
void Init_CanBus_C(uint32_t baudRate);
bool Can_Reseive_Menssage(void);
bool Can_Reseive_Menssage_2(void);
void check_if_recive(uint8_t);

/*******************************************************************************
 * Code
 ******************************************************************************/
/*!
 * @brief FlexCAN Call Back function
 */
static void flexcan_callback(CAN_Type *base, flexcan_handle_t *handle, status_t status, uint32_t result, void *userData)
{
    switch (status)
    {
        case kStatus_FLEXCAN_RxIdle:
            if (RX_MESSAGE_BUFFER_NUM == result)
            {
                rxComplete = true;
            }
            break;

        case kStatus_FLEXCAN_TxIdle:
            if (TX_MESSAGE_BUFFER_NUM == result)
            {
                txComplete = true;
            }
            break;

        case kStatus_FLEXCAN_WakeUp:
            wakenUp = true;
            break;

        default:
            break;
    }
}

TimerHandle_t SwTimerHandle = NULL;
/*!
 * @brief Main function
 */
int main(void)
{
//    flexcan_config_t flexcanConfig;
//    flexcan_rx_mb_config_t mbConfig;
//    uint8_t node_type;

    /* Initialize board hardware. */
    BOARD_InitPins();
    BOARD_BootClockRUN();

    BOARD_InitDebugConsole();

    PRINTF("********* FLEXCAN Interrupt EXAMPLE 33 *********\r\n");
    PRINTF("    Message format: Standard (11 bit id)\r\n");
    PRINTF("    Message buffer %d used for Rx.\r\n", RX_MESSAGE_BUFFER_NUM);
    PRINTF("    Message buffer %d used for Tx.\r\n", TX_MESSAGE_BUFFER_NUM);
    PRINTF("    Interrupt Mode: Enabled\r\n");
    PRINTF("    Operation Mode: TX and RX --> Normal\r\n");
    PRINTF("*********************************************\r\n\r\n");

    do
    {
        PRINTF("Please select local node as A or B:\r\n");
        PRINTF("Note: Node B should start first.\r\n");
        PRINTF("Node:");
        node_type = GETCHAR();
        PRINTF("%c", node_type);
        PRINTF("\r\n");
    } while ((node_type != 'A') && (node_type != 'B') && (node_type != 'a') && (node_type != 'b'));

    /* Select mailbox ID. */
    if ((node_type == 'A') || (node_type == 'a'))
    {
//        txIdentifier = 0x321;
//        rxIdentifier = 0x123;

        txIdentifier = 0x7DF;
        rxIdentifier = 0x000;
    }
    else
    {
        txIdentifier = 0x123;
        rxIdentifier = 0x321;
    }

    /* Inicializo dispositivo de CanBus */
    for(uint8_t i=0;i<3;i++)
    {
    	PRINTF("Configuro con %d.\r\n",baudRates[i]);
    	Init_CanBus_C(baudRates[i]);
    	if(Can_Reseive_Menssage())
    	{
    		PRINTF("Found_daudaje %d.\r\n",baudRates[i]);
    		break;
    	}
    }

    for(uint8_t i=0;i<20;i++)
    {
    	for(uint8_t j=0;j<20;j++)
    	{
    		if(Can_Reseive_Menssage_2())
    		{
    			Found_ID[i][j].id_found = frame.id >> CAN_ID_STD_SHIFT;
    			Found_ID[i][j].Byte0 = frame.dataByte0;
    			Found_ID[i][j].Byte1 = frame.dataByte1;
    			Found_ID[i][j].Byte2 = frame.dataByte2;
    			Found_ID[i][j].Byte3 = frame.dataByte3;
    			Found_ID[i][j].timestamp = frame.timestamp;
    			PRINTF("KEEP IDs 0x%3x, Byte1 0x%x, Byte2 0x%x, Byte3 0x%x\n",Found_ID[i][j].id_found, frame.dataByte1, frame.dataByte2,frame.dataByte3);
    		}
    	}
    }

    PRINTF("Listado de ID encntrados\n");
    for(uint8_t i=0;i<20;i++)
    {
    	for(uint8_t j=0;j<20;j++)
    	{
    		PRINTF("ID,[0x%3x],Byte0,[0x%x],Byte1,[0x%x],Byte2,[0x%x],Byte3,[0x%x],TimeStamp,%d\n",Found_ID[i][j].id_found, Found_ID[i][j].Byte0, Found_ID[i][j].Byte1, Found_ID[i][j].Byte2, Found_ID[i][j].Byte3,Found_ID[i][j].timestamp);
    	}
    }

    /* *****************************************
     *  Inicializo Hilo
     * ****************************************/
    xTaskCreate(producer_task, "PRODUCER_TASK", configMINIMAL_STACK_SIZE + 128, NULL, TASK_PRIO, NULL);
    /* ****************************************
     *  Incializacion de Timers
     *  ************************************ */
    SwTimerHandle = xTimerCreate("SwTimer",          /* Text name. */
    		SW_TIMER_PERIOD_MS, /* Timer period. */
			pdTRUE,             /* Enable auto reload. */
			0,                  /* ID is not used. */
			SwTimerCallback);   /* The callback function. */


    if ((node_type == 'A') || (node_type == 'a'))
    {
        PRINTF("Press any key to trigger one-shot transmission\r\n\r\n");
        frame.dataByte0 = 0;
    }
    else
    {
        PRINTF("Start to Wait data from Node A\r\n\r\n");
    }


//    /* Start timer. */
//    xTimerStart(SwTimerHandle, 0);
    /* Start scheduling. */
    vTaskStartScheduler();
    for (;;)
    	;
}

void Init_CanBus_C(uint32_t baudRate)
{
	/* Get FlexCAN module default Configuration. */
		    /*
		     * flexcanConfig.clkSrc = kFLEXCAN_ClkSrcOsc;
		     * flexcanConfig.baudRate = 1000000U;
		     * flexcanConfig.baudRateFD = 2000000U;
		     * flexcanConfig.maxMbNum = 16;
		     * flexcanConfig.enableLoopBack = false;
		     * flexcanConfig.enableSelfWakeup = false;
		     * flexcanConfig.enableIndividMask = false;
		     * flexcanConfig.enableDoze = false;
		     * flexcanConfig.timingConfig = timingConfig;
		     */
		    FLEXCAN_GetDefaultConfig(&flexcanConfig);
		    flexcanConfig.baudRate = baudRate;	/* Change of congiguration BaudRate */

		/* Init FlexCAN module. */
		#if (!defined(DEMO_FORCE_CAN_SRC_OSC)) || !DEMO_FORCE_CAN_SRC_OSC
		#if (!defined(FSL_FEATURE_FLEXCAN_SUPPORT_ENGINE_CLK_SEL_REMOVE)) || !FSL_FEATURE_FLEXCAN_SUPPORT_ENGINE_CLK_SEL_REMOVE
		    flexcanConfig.clkSrc = kFLEXCAN_ClkSrcPeri;
		#else
		#if defined(CAN_CTRL1_CLKSRC_MASK)
		    if (!FSL_FEATURE_FLEXCAN_INSTANCE_SUPPORT_ENGINE_CLK_SEL_REMOVEn(EXAMPLE_CAN))
		    {
		        flexcanConfig.clkSrc = kFLEXCAN_ClkSrcPeri;
		    }
		#endif
		#endif /* FSL_FEATURE_FLEXCAN_SUPPORT_ENGINE_CLK_SEL_REMOVE */
		#endif /* DEMO_FORCE_CAN_SRC_OSC */
		/* If special quantum setting is needed, set the timing parameters. */
		#if (defined(SET_CAN_QUANTUM) && SET_CAN_QUANTUM)
		    flexcanConfig.timingConfig.phaseSeg1 = PSEG1;
		    flexcanConfig.timingConfig.phaseSeg2 = PSEG2;
		    flexcanConfig.timingConfig.propSeg   = PROPSEG;
		#if (defined(FSL_FEATURE_FLEXCAN_HAS_FLEXIBLE_DATA_RATE) && FSL_FEATURE_FLEXCAN_HAS_FLEXIBLE_DATA_RATE)
		    flexcanConfig.timingConfig.fphaseSeg1 = FPSEG1;
		    flexcanConfig.timingConfig.fphaseSeg2 = FPSEG2;
		    flexcanConfig.timingConfig.fpropSeg   = FPROPSEG;
		#endif
		#endif

		#if (defined(USE_IMPROVED_TIMING_CONFIG) && USE_IMPROVED_TIMING_CONFIG)
		    flexcan_timing_config_t timing_config;
		    memset(&timing_config, 0, sizeof(flexcan_timing_config_t));
		#if (defined(USE_CANFD) && USE_CANFD)
		    if (FLEXCAN_FDCalculateImprovedTimingValues(flexcanConfig.baudRate, flexcanConfig.baudRateFD, EXAMPLE_CAN_CLK_FREQ,
		                                                &timing_config))
		    {
		        /* Update the improved timing configuration*/
		        memcpy(&(flexcanConfig.timingConfig), &timing_config, sizeof(flexcan_timing_config_t));
		    }
		    else
		    {
		        PRINTF("No found Improved Timing Configuration. Just used default configuration\r\n\r\n");
		    }
		#else
		    if (FLEXCAN_CalculateImprovedTimingValues(flexcanConfig.baudRate, EXAMPLE_CAN_CLK_FREQ, &timing_config))
		    {
		        /* Update the improved timing configuration*/
		        memcpy(&(flexcanConfig.timingConfig), &timing_config, sizeof(flexcan_timing_config_t));
		    }
		    else
		    {
		        PRINTF("No found Improved Timing Configuration. Just used default configuration\r\n\r\n");
		    }
		#endif
		#endif

		#if (defined(USE_CANFD) && USE_CANFD)
		    FLEXCAN_FDInit(EXAMPLE_CAN, &flexcanConfig, EXAMPLE_CAN_CLK_FREQ, BYTES_IN_MB, true);
		#else
		    FLEXCAN_Init(EXAMPLE_CAN, &flexcanConfig, EXAMPLE_CAN_CLK_FREQ);
		#endif

		    /* Create FlexCAN handle structure and set call back function. */
		    FLEXCAN_TransferCreateHandle(EXAMPLE_CAN, &flexcanHandle, flexcan_callback, NULL);

		    /* Set Rx Masking mechanism. */
		    FLEXCAN_SetRxMbGlobalMask(EXAMPLE_CAN, FLEXCAN_RX_MB_STD_MASK(rxIdentifier, 0, 0));

		    /* Setup Rx Message Buffer. */
		    mbConfig.format = kFLEXCAN_FrameFormatStandard;
		    mbConfig.type   = kFLEXCAN_FrameTypeData;
		    mbConfig.id     = FLEXCAN_ID_STD(rxIdentifier);
		#if (defined(USE_CANFD) && USE_CANFD)
		    FLEXCAN_SetFDRxMbConfig(EXAMPLE_CAN, RX_MESSAGE_BUFFER_NUM, &mbConfig, true);
		#else
		    FLEXCAN_SetRxMbConfig(EXAMPLE_CAN, RX_MESSAGE_BUFFER_NUM, &mbConfig, true);
		#endif

		/* Setup Tx Message Buffer. */
		#if (defined(USE_CANFD) && USE_CANFD)
		    FLEXCAN_SetFDTxMbConfig(EXAMPLE_CAN, TX_MESSAGE_BUFFER_NUM, true);
		#else
		    FLEXCAN_SetTxMbConfig(EXAMPLE_CAN, TX_MESSAGE_BUFFER_NUM, true);
		#endif
}

bool Can_Reseive_Menssage(void)
{
	if (wakenUp)
	{
		PRINTF("B has been waken up!\r\n\r\n");
	}

	/* Start receive data through Rx Message Buffer. */
	rxXfer.mbIdx = RX_MESSAGE_BUFFER_NUM;
	#if (defined(USE_CANFD) && USE_CANFD)
	rxXfer.framefd = &frame;
	FLEXCAN_TransferFDReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer);
	#else
	rxXfer.frame = &frame;
	FLEXCAN_TransferReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer);
	#endif

	PRINTF("Empiezo tiempo de espera para escuchar algo \r\n\r\n");

	for(uint32_t i = 0;i<1000000;i++)
	{
		if(rxComplete)
		{
			PRINTF("ID1:[0x%3x], ID2: [0x%3x], length: [%d] DataByte0 0x%x, DataByte1 0x%x,DataByte2 0x%x,DataByte3 0x%x\n", frame.id >> CAN_ID_STD_SHIFT, frame.id, frame.length, frame.dataByte0, frame.dataByte1, frame.dataByte2, frame.dataByte3);
			return true;
		}

	}
	PRINTF("Finalizo tiempo de espera, busco otro \r\n\r\n");
	return false;
}

bool Can_Reseive_Menssage_2(void)
{
	if (wakenUp)
	{
		PRINTF("B has been waken up!\r\n\r\n");
	}

	/* Start receive data through Rx Message Buffer. */
	rxXfer.mbIdx = RX_MESSAGE_BUFFER_NUM;
	#if (defined(USE_CANFD) && USE_CANFD)
	rxXfer.framefd = &frame;
	FLEXCAN_TransferFDReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer);
	#else
	rxXfer.frame = &frame;
	FLEXCAN_TransferReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer);
	#endif

	PRINTF("Empiezo tiempo de espera para escuchar algo \r\n\r\n");

	for(uint32_t i = 0;i<1000000;i++)
	{
		if(rxComplete)
		{
			PRINTF("ID1:[0x%3x], ID2: [0x%3x], length: [%d] DataByte0 0x%x, DataByte1 0x%x,DataByte2 0x%x,DataByte3 0x%x\n", frame.id >> CAN_ID_STD_SHIFT, frame.id, frame.length, frame.dataByte0, frame.dataByte1, frame.dataByte2, frame.dataByte3);
			return true;
		}

	}
	PRINTF("Finalizo tiempo de espera, busco otro \r\n\r\n");
	return false;
}

static void producer_task(void *pvParameters)
{

//    PRINTF("Producer_task created.\r\n");
//    xSemaphore_producer = xSemaphoreCreateBinary();

	txIdentifier = 0x7E0; /* request  ECU #1 */
	rxIdentifier = 0x7E8; /* response ECU #1 */

	/* ***************** Setup Rx Message Buffer. **************** */
	/* Set Rx Masking mechanism. */
	FLEXCAN_SetRxMbGlobalMask(EXAMPLE_CAN, FLEXCAN_RX_MB_STD_MASK(rxIdentifier, 0, 0));

	mbConfig.format = kFLEXCAN_FrameFormatStandard;
	mbConfig.type   = kFLEXCAN_FrameTypeData;
	//mbConfig.id     = FLEXCAN_ID_STD(My_rxidentifier[i]);
	mbConfig.id     = FLEXCAN_ID_STD(0x000);
	#if (defined(USE_CANFD) && USE_CANFD)
	FLEXCAN_SetFDRxMbConfig(EXAMPLE_CAN, RX_MESSAGE_BUFFER_NUM, &mbConfig, true);
	#else
	FLEXCAN_SetRxMbConfig(EXAMPLE_CAN, RX_MESSAGE_BUFFER_NUM, &mbConfig, true);
	#endif

	/* Setup Tx Message Buffer. */
	#if (defined(USE_CANFD) && USE_CANFD)
	FLEXCAN_SetFDTxMbConfig(EXAMPLE_CAN, TX_MESSAGE_BUFFER_NUM, true);
	#else
	FLEXCAN_SetTxMbConfig(EXAMPLE_CAN, TX_MESSAGE_BUFFER_NUM, true);
	#endif
	/* **************************************************************/

    while (1)
        {
            if ((node_type == 'A') || (node_type == 'a'))
            {
                GETCHAR();

                frame.id     = FLEXCAN_ID_STD(txIdentifier);
                frame.format = kFLEXCAN_FrameFormatStandard;
                frame.type   = kFLEXCAN_FrameTypeData;
                frame.length = DLC;
    			#if (defined(USE_CANFD) && USE_CANFD)
                frame.brs = 1;
    			#endif

                frame.dataByte0 = 0x02;		//longitud de bytes
                frame.dataByte1 = 0x01;		//peticion en modo 1
                frame.dataByte2 = 0x00;		//PID 0x00 (Solicitud de lista de PIDS soportados)
                frame.dataByte3 = 0x00;
                frame.dataByte4 = 0x00;
                frame.dataByte5 = 0x00;
                frame.dataByte6 = 0x00;
                frame.dataByte7 = 0x00;

                txXfer.mbIdx = TX_MESSAGE_BUFFER_NUM;
    			#if (defined(USE_CANFD) && USE_CANFD)
                txXfer.framefd = &frame;
                if(FLEXCAN_TransferFDSendNonBlocking(EXAMPLE_CAN, &flexcanHandle, &txXfer) == kStatus_Success)
                {
                	PRINTF("Success send information \n");
                }
    			#else
                txXfer.frame = &frame;
                FLEXCAN_TransferSendNonBlocking(EXAMPLE_CAN, &flexcanHandle, &txXfer);
    			#endif

                xTimerStart(SwTimerHandle, 0); /* 200 milisegundos */
                while (!txComplete || watch_dog)
                {
                };
                if(watch_dog)
                {
                	PRINTF("Sale por Watch dog\n");
                }
                txComplete = false;
                watch_dog = false;
                xTimerStop(SwTimerHandle, 0);

                bool receibe_data = false;
                while(receibe_data)
                {
                	/* Start receive data through Rx Message Buffer. */
                	rxXfer.mbIdx = RX_MESSAGE_BUFFER_NUM;
					#if (defined(USE_CANFD) && USE_CANFD)
                	rxXfer.framefd = &frame;
                	if(FLEXCAN_TransferFDReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer) == kStatus_Success)
                	{
                		PRINTF("Success receibe information \n");
                	}
					#else
                	rxXfer.frame = &frame;
                	FLEXCAN_TransferReceiveNonBlocking(EXAMPLE_CAN, &flexcanHandle, &rxXfer);
					#endif

                	//                /* Wait until Rx MB full. */
                	//                while (!rxComplete)
                	//                {
                	//                };
                	//                rxComplete = false;

                	xTimerStart(SwTimerHandle, 0); /* 200 milisegundos */
                	while (!rxComplete || watch_dog)
                	{
                	};
                	if(watch_dog)
                	{
                		PRINTF("Sale por Watch dog\n");
                	}
                	rxComplete = false;
                	watch_dog = false;
                	xTimerStop(SwTimerHandle, 0);

                	PRINTF("ID a comparar 0x%3x\n",frame.id >> CAN_ID_STD_SHIFT);
                	for(uint8_t i = 0; i<10;i++)
                	{
                		if(frame.id >> CAN_ID_STD_SHIFT == PIDs[i])
                		{
                			receibe_data = true;
                			PRINTF("Rx MB ID: 0x%3x, dataByte0: 0x%x, dataByte1: 0x%x, dataByte2: 0x%x, dataByte3: 0x%x, dataByte4: 0x%x, dataByte5: 0x%x, dataByte6: 0x%x, dataByte7: 0x%x, Time stamp: %d\r\n", frame.id >> CAN_ID_STD_SHIFT,
                					frame.dataByte0, frame.dataByte1, frame.dataByte2, frame.dataByte3, frame.dataByte4,
									frame.dataByte5, frame.dataByte6, frame.dataByte7,frame.timestamp);
                			PRINTF("Press any key to trigger the next transmission!\r\n\r\n");
                			//frame.dataByte0++;
                			//frame.dataByte1 = 0x55;
                			break;
                		}
                	}

//                	PRINTF("Rx MB ID: 0x%3x, dataByte0: 0x%x, dataByte1: 0x%x, dataByte2: 0x%x, dataByte3: 0x%x, dataByte4: 0x%x, dataByte5: 0x%x, dataByte6: 0x%x, dataByte7: 0x%x, Time stamp: %d\r\n", frame.id >> CAN_ID_STD_SHIFT,
//                			frame.dataByte0, frame.dataByte1, frame.dataByte2, frame.dataByte3, frame.dataByte4,
//							frame.dataByte5, frame.dataByte6, frame.dataByte7,frame.timestamp);
//                	PRINTF("Press any key to trigger the next transmission!\r\n\r\n");
//                	//frame.dataByte0++;
//                	//frame.dataByte1 = 0x55;
                }

            }
        }
}

/*!
 * @brief Software timer callback.
 */
static void SwTimerCallback(TimerHandle_t xTimer)
{
    PRINTF("Tick.\r\n");
    watch_dog = true;
}
