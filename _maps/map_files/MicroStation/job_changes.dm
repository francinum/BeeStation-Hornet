#define JOB_MODIFICATION_MAP_NAME "MicroStation"

/*
LEGEND:
 - [JOB NAME]
 ! [NOTE]
 * [MODIFICATION - SUBSUME JOB]
*/

/*
- Command
 - Captain
  * CHIEF ENGINEER
  * CHIEF MEDICAL OFFICER
 - Head of Personnel
 - Head of Security
 - Research Director
*/

MAP_REMOVE_JOB(ce)
MAP_REMOVE_JOB(cmo)


/*
- Security
 - Head of Security
  * WARDEN
 - Security Officer
*/

MAP_REMOVE_JOB(warden)

/*
- Medical
 - Medical Doctor
  * VIROLOGY
  * CHEMISTRY
*/

MAP_REMOVE_JOB(virologist)
MAP_REMOVE_JOB(chemist)

/*
- Research
*/

/*
- Engineering
*/

/*
- Cargo
 - Cargo Technician
  * QUARTERMASTER
  ! Given the QM's access. Not
*/

/*
- Civilian
*/
