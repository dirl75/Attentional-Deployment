# Attentional-Deployment

The main file is the function "AttentionDeploymentTask" (herein ADT), which runs a session of the task when executed.

# The task requires Psychtoolbox (http://psychtoolbox.org/)

# At the start, ADT calls a script called "settings_AttentionDeployment," which contains all the task parameters that must be set.

# ADT also calls "AttentionDeploymentTask_Practice" and its corresponding "settings_AttentionDeployment_Practice," both of which run the practice trials at the beginning of the session.

# Other functions that are called by ADT: "GetSubjectInfo_AttentionDeployment", "saveBehavData_AttDeploy" 

# ADT requires a folder called "Imagenes Tarea DA" containing all the stimuli that the task uses, plus a couple of images that are displayed while participants deliver their valence and intensity ratings.

# ADT also requires a file called "Picture_Sequences.mat", containing the 3 possible stimuli sequences presented during the task.

# running one session with ADT outputs a .txt and a .mat. Both files have the same data, corresponding to the session's behavioral data. They are saved to a folder called "data" which must be in the folder where ADT is.




