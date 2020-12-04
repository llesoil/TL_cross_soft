#!/bin/sh

numb='151'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 280 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.0,2.8,0.5,0.9,0.9,3,2,10,35,280,1,28,10,3,4,66,38,5,2000,-2:-2,umh,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"