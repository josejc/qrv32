/* SBI Extension IDs */
#define EID_BASE			0x10
#define EID_TIME			0x54494D45
#define EID_IPI				0x735049	// Interprocessor Interrupt	
#define EID_RFNC			0x52464E43	// Remote fence operations
#define EID_HSM				0x48534D	// Hart State Management
#define EID_DBCN			0x4442434E	// Debug Console Extension

/* SBI function ID for DBCN extension */
#define FID_DBCN_WRITE			0

/* SBI function ID for TIME extension */
#define FID_TIME_SET_TIMER 		0
