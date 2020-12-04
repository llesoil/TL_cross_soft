#!/bin/sh

numb='467'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.1,1.4,4.4,0.3,0.7,0.8,3,1,16,45,220,1,30,50,3,2,69,18,5,1000,1:1,hex,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"