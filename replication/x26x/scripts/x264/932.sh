#!/bin/sh

numb='933'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.6,1.3,2.6,0.5,0.9,0.7,0,0,4,15,260,4,25,20,3,4,69,28,3,1000,1:1,umh,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"