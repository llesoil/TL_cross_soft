#!/bin/sh

numb='2495'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 45 --keyint 290 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.3,3.4,0.6,0.9,0.4,1,1,12,45,290,2,28,20,3,0,60,48,4,2000,1:1,dia,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"