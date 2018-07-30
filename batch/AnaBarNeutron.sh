#!/bin/bash
#PBS -N CDetOptical
#PBS -m n
#PBS -M lydia.lorenti.15@cnu.edu
#PBS -l walltime=40:00:00
#PBS -V

export nevents=100
export tempdir=/home/llorenti/CDetOptical/batch

export MACRO_PATH=/home/llorenti/CDetOptical/macros/
export MCMACRO=$tempdir/AnaBarMC_$RUN_NUMBER.mac

echo "/control/macroPath $MACRO_PATH"	 	                         >   $MCMACRO
echo "/AnaBarMC/physics/addPhysics standard_opt3"                        >>   $MCMACRO
echo "/AnaBarMC/physics/optical 1"	                                 >>  $MCMACRO
echo "/run/initialize"                                                   >>  $MCMACRO
echo "/AnaBarMC/generator/Mode 1"                              >>  $MCMACRO
echo "/AnaBarMC/generator/InputFile $tempdir/data/AnaBarMC_Gen_$RUN_NUMBER.root" >>  $MCMACRO
echo "/AnaBarMC/analysis/setOutputFile $tempdir/rootfiles/AnaBarMC_$RUN_NUMBER.root" >>  $MCMACRO

cd $tempdir
source /home/llorenti/geant4/G4setup_batch.sh
export ROOTSYS=/cern/root/pro
export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
export PATH=$ROOTSYS/bin:$PATH
export DISPLAY=jlabanalysis.pcs.cnu.edu:0.0
#nohup root -l -q GenCosmics.C++\($nevents,$RUN_NUMBER\) #>& /dev/null
nohup /home/llorenti/geant4/bin/Linux-g++/AnaBarMC $MCMACRO #>& /dev/null
echo "****************** AnaBarMC Finished"

cp    ${tempdir}/rootfiles/"AnaBarMC_$RUN_NUMBER.root"   ${OUTPUT_DIR}/
rm -f ${tempdir}/rootfiles/"AnaBarMC_$RUN_NUMBER.root"
rm -f $MCMACRO