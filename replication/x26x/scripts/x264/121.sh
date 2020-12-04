#!/bin/sh

numb='122'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 20 --keyint 230 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.6,1.2,0.8,0.4,0.7,0.2,2,2,4,20,230,1,21,30,5,4,62,18,2,1000,-2:-2,umh,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"