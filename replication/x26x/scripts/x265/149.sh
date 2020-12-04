#!/bin/sh

numb='150'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 5 --keyint 220 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.3,1.3,1.8,0.4,0.9,0.1,0,0,0,5,220,3,22,50,3,4,61,28,1,2000,1:1,dia,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"