#!/bin/sh

numb='1197'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.5,1.3,2.4,0.5,0.9,0.9,0,1,6,40,290,3,20,40,3,0,64,38,2,2000,-2:-2,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"