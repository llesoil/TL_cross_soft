#!/bin/sh

numb='1874'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 40 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.4,2.6,0.3,0.9,0.5,1,2,6,40,280,1,26,0,5,4,66,28,1,1000,1:1,hex,show,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"