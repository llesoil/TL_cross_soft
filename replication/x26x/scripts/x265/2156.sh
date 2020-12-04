#!/bin/sh

numb='2157'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 25 --keyint 210 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.3,1.3,3.2,0.5,0.7,0.5,2,0,10,25,210,4,30,30,3,0,65,18,1,2000,-2:-2,dia,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"