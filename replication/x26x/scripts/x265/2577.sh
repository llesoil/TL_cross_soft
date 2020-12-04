#!/bin/sh

numb='2578'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 2.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.4,2.8,0.4,0.8,0.2,2,0,8,0,260,2,23,30,4,1,66,28,1,2000,1:1,hex,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"