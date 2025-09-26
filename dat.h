#define HZ          (100)       /*! clock frequency */
#define MS2HZ       (1000/HZ)   /*! millisec per clock tick */
#define TK2SEC(t)   ((t)/HZ)    /*! ticks to seconds */
#define MS2TK(t)    ((t)/MS2HZ) /*! milliseconds to ticks */

#define MACHP(n)    (n == 0 ? (Mach*)(MACHADDR) : (Mach*)0)
#define AOUT_MAGIC	Z_MAGIC

typedef struct sbiret sbiret;

struct sbiret {
    ulong  error;
    ulong  value;
};
