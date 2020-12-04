#!/bin/sh

numb='2713'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 50 --keyint 270 --lookahead-threads 0 --min-keyint 29 --qp 30 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.6,1.2,0.2,0.6,0.7,0.6,3,1,12,50,270,0,29,30,3,2,65,28,5,2000,-2:-2,dia,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"