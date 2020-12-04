#!/bin/sh

numb='3043'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 25 --keyint 210 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.3,1.1,2.0,0.3,0.6,0.5,3,2,14,25,210,4,22,20,5,2,65,48,3,1000,-1:-1,dia,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"