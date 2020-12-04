#!/bin/sh

numb='2204'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.2,1.2,1.8,0.4,0.9,0.3,2,0,6,45,210,2,24,10,5,2,65,38,2,1000,-1:-1,umh,show,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"