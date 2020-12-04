#!/bin/sh

numb='2086'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.2,1.4,0.2,0.2,0.8,0.1,2,2,8,50,280,4,24,50,5,4,67,48,2,2000,-1:-1,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"