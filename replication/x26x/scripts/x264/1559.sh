#!/bin/sh

numb='1560'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 50 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.5,1.1,3.4,0.5,0.9,0.1,1,0,6,50,230,2,28,20,3,0,67,28,3,1000,-1:-1,hex,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"