#!/bin/sh

numb='1855'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 50 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.5,1.4,4.6,0.5,0.7,0.9,3,1,2,45,220,1,27,50,3,4,64,38,4,2000,1:1,dia,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"