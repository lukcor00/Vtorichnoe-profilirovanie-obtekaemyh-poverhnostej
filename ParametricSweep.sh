#PseudoCode bullshit for parametric sweep

. $WM_PROJECT_DIR/bin/tools/RunFunctions

sed -i 's/2500/3000/g' system/controlDict

for i in 10000
do
   mkdir $i
   
   runParallel -s $i-1 foamDictionary "$(foamListTimes -latestTime -processor)"/U -entry boundaryField/walls_rotor/rpm/value -set $i
   runParallel -s $i-3 foamDictionary "$(foamListTimes -latestTime -processor)"/U -entry boundaryField/walls_rotor_tip/rpm/value -set $i
   runApplication -s $i-2 foamDictionary BC -entry motion/rpm -set $i
   for k in 1.1e-4 1.2e-4 0.9e-4 0.8e-4 0.7e-4 0.6e-4 0.5e-4 0.4e-4 0.3e-4 0.2e-4 0.1e-4 0.1e-6
   do
      echo "--------- Parameter -----------"
      echo "$i        $k"
      runParallel -s $i-$k foamDictionary "$(foamListTimes -latestTime -processor)"/U -entry boundaryField/inlet/volumetricFlowRate/value -set $k
      echo "_______________________________"
      runParallel -s $i-$k foamRun
      runApplication -s $i-$k reconstructPar -latestTime
      mv "$(foamListTimes -latestTime -processor)" $i/$k
      mv postProcessing $i/postProcessing_$k
      rm -r processor*/"$(foamListTimes -latestTime -processor)"
      echo "--------- End of Iteration ----"
   done
done

echo "--------- End of Sweep --------"