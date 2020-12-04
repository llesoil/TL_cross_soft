#!/bin/sh

numb='323'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 30 --keyint 220 --lookahead-threads 4 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.5,1.2,3.4,0.5,0.6,0.0,2,2,0,30,220,4,28,50,3,1,61,18,2,1000,1:1,dia,show,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"