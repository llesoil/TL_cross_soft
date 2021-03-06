#!/bin/sh

numb='321'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 15 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.5,1.4,3.0,0.4,0.8,0.3,0,2,0,15,260,1,29,0,5,0,68,38,4,1000,-1:-1,umh,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"