#!/bin/sh

numb='2465'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 40 --keyint 290 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.4,0.6,0.3,0.7,0.2,1,0,10,40,290,1,25,40,3,4,61,28,5,1000,1:1,hex,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"