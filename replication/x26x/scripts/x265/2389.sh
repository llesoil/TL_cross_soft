#!/bin/sh

numb='2390'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 0 --keyint 220 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.5,1.4,4.4,0.5,0.9,0.7,1,1,0,0,220,2,23,40,3,4,68,28,1,2000,-2:-2,dia,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"