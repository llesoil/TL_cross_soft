#!/bin/sh

numb='893'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 5 --keyint 280 --lookahead-threads 1 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.1,1.4,2.0,0.5,0.6,0.6,3,0,14,5,280,1,22,20,3,4,61,38,3,1000,1:1,dia,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"