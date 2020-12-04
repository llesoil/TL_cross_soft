#!/bin/sh

numb='2401'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 40 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.4,1.0,0.5,0.8,0.5,1,1,10,40,220,0,20,0,5,2,68,38,3,2000,-1:-1,umh,crop,medium,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"