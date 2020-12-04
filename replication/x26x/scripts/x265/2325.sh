#!/bin/sh

numb='2326'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.3,1.2,2.0,0.3,0.7,0.6,3,0,14,0,300,1,28,20,5,4,66,18,4,2000,-1:-1,umh,show,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"