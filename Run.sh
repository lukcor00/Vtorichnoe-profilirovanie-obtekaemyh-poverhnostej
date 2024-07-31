paraFoam -touch -builtin
cp 0.orig/* 0/
changeDictionary | tee logs/log.changeDictionary
createBaffles -overwrite | tee logs/log.createBaffles
splitBaffles -overwrite | tee logs/log.splitBaffles
createNonConformalCouples NCC1 NCC1_SHADOW -overwrite | tee logs/log.createNonConformalCouples
extrudeMesh | tee logs/log.extrudeMesh
#mapFields ../coarse-new -sourceTime latestTime -mapMethod mapNearest | tee logs/log.mapfield
decomposePar | tee logs/log.decomposePar
mpirun checkMesh -parallel| tee logs/log.checkMesh
foamDictionary BC -entry turbulent/model -set kEpsilon
mpirun foamRun -parallel | tee logs/log.foamRun.kEpsilon
foamDictionary BC -entry turbulent/model -set kOmegaSST
mpirun foamRun -parallel | tee logs/log.foamRun.kOmegaSST
reconstructPar | tee logs/log.reconstructPar