#!/bin/sh

numb='346'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 50 --keyint 250 --lookahead-threads 4 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.5,1.0,1.0,0.5,0.8,0.9,0,1,0,50,250,4,26,20,3,2,67,38,4,1000,-2:-2,umh,show,medium,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"