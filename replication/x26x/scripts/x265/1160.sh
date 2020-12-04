#!/bin/sh

numb='1161'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 40 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.4,4.4,0.2,0.9,0.0,2,0,14,40,290,0,24,40,4,0,66,28,6,2000,-2:-2,dia,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"