#!/bin/sh

numb='2470'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 25 --keyint 240 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.3,1.1,2.6,0.4,0.9,0.8,3,1,10,25,240,0,27,40,3,0,60,18,4,2000,-2:-2,umh,crop,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"