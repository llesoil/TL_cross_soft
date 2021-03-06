#!/bin/sh

numb='1652'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 35 --keyint 220 --lookahead-threads 2 --min-keyint 21 --qp 0 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.2,0.2,0.2,0.6,0.3,2,1,8,35,220,2,21,0,3,1,65,48,3,2000,-1:-1,hex,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"