
#include <stdio.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <mach/mach_init.h>
#include <mach-o/dyld_images.h>
#include <unistd.h> 

void listProcesses() {
    int mib[4];
    size_t len = 0;
    struct kinfo_proc *procs = NULL;

	// Calls for process retrival
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_ALL;
    mib[3] = 0;

	//Process Memory Information
    len = 0;
    if (sysctl(mib, 4, NULL, &len, NULL, 0) == -1) {
        perror("sysctl");
        return;
    }
	
    procs = malloc(len);
    if (!procs) {
        perror("malloc"); // Error Handling for memory allocation
        return;
    }

    if (sysctl(mib, 4, procs, &len, NULL, 0) == -1) {
        perror("sysctl");
        free(procs);
        return;
    }

    int numProcs = len / sizeof(struct kinfo_proc);

 	printf("\033[H\033[J");

    int seenPids[numProcs]; // Array to track seen PIDs
    memset(seenPids, 0, sizeof(seenPids)); // Initialize all elements to 0

    for (int i = 0; i < numProcs; i++) {
        bool isNew = true;
        for (int j = 0; j < i; j++) {
            if (procs[i].kp_proc.p_pid == procs[j].kp_proc.p_pid) {
                isNew = false;
                break;
            }
        }
        if (isNew) {
            printf("PID: %d | Name: %s\n", procs[i].kp_proc.p_pid, procs[i].kp_proc.p_comm);
        }
    }
		free(procs);
}

int main (int argc, const char * argv[]) {
	if(argc > 1 && strcmp(argv[1], "-i") == 0) {
		printf("Monitoring Processes...\n");
		while(1) {
			listProcesses();
			sleep(5);
		}

	} else {
		printf("Listing Processes...\n");
		listProcesses();
		return 0;
	}
}