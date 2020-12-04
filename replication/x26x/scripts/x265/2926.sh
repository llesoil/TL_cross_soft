#!/bin/sh

numb='2927'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 0 --keyint 240 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.4,3.0,0.3,0.9,0.4,0,1,4,0,240,1,24,50,5,0,64,48,4,2000,-1:-1,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"