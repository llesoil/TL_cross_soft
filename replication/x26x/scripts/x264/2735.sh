#!/bin/sh

numb='2736'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 25 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.3,1.0,2.0,0.4,0.8,0.9,3,1,8,25,240,4,30,50,4,1,60,48,6,2000,1:1,hex,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"