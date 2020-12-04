#!/bin/sh

numb='1648'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 35 --keyint 220 --lookahead-threads 0 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.5,1.2,1.2,0.3,0.6,0.8,1,2,16,35,220,0,21,10,5,3,61,48,5,1000,-2:-2,dia,crop,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"