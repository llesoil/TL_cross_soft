#!/bin/sh

numb='1760'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 270 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,0.5,1.6,1.1,2.2,0.3,0.7,0.3,1,2,0,45,270,1,21,0,5,0,65,18,1,2000,-2:-2,dia,show,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"