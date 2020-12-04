#!/bin/sh

numb='1269'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 10 --keyint 290 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.2,0.6,0.6,0.7,0.3,1,2,14,10,290,3,24,30,3,1,64,48,5,2000,1:1,hex,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"