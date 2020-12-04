#!/bin/sh

numb='1406'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 40 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.0,1.4,0.3,0.9,0.4,1,0,10,40,220,3,29,0,3,2,65,18,5,2000,1:1,dia,show,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"