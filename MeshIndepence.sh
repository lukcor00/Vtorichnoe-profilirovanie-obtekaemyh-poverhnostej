#PseudoCode bullshit for parametric sweep

. $WM_PROJECT_DIR/bin/tools/RunFunctions


for k in 0.1e-6 1e-4
do
      echo "--------- Parameter -----------"
      echo "$k"
      runParallel -s $k foamDictionary "$(foamListTimes -latestTime -processor)"/U -entry boundaryField/inlet/volumetricFlowRate/value -set $k
      echo "_______________________________"
      runParallel -s $k foamRun
      runApplication -s $k reconstructPar -latestTime
      mv "$(foamListTimes -latestTime -processor)" $k
      mv postProcessing postProcessing_$k
      rm -r processor*/"$(foamListTimes -latestTime -processor)"
      echo "--------- End of Iteration ----"
done


echo "--------- End of Sweep --------"