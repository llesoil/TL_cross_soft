#!/bin/sh

numb='869'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.5,1.1,0.4,0.2,0.7,0.5,1,0,16,15,250,0,23,10,3,4,69,48,3,1000,1:1,hex,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"