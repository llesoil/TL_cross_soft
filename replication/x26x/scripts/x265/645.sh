#!/bin/sh

numb='646'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.1,3.2,0.5,0.9,0.3,0,2,8,20,290,1,29,0,5,1,60,48,4,1000,-2:-2,dia,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"