#!/bin/sh

numb='2474'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 5 --keyint 280 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.0,3.0,0.4,0.7,0.5,1,0,6,5,280,3,26,20,5,1,66,38,1,2000,-2:-2,dia,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"