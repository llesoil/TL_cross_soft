#!/bin/sh

numb='355'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 10 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.0,0.2,0.6,0.9,0.3,2,0,2,10,290,2,27,0,3,2,67,18,2,2000,1:1,dia,show,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"