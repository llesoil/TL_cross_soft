#!/bin/sh

numb='61'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 15 --keyint 300 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.3,1.4,3.8,0.2,0.9,0.3,0,1,8,15,300,0,21,30,3,2,60,28,5,1000,-2:-2,umh,show,veryslow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"