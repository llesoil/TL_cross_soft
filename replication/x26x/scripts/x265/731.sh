#!/bin/sh

numb='732'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 10 --keyint 290 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.4,4.8,0.3,0.8,0.1,1,2,0,10,290,2,28,20,4,3,65,48,2,2000,-2:-2,dia,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"