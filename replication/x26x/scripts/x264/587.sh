#!/bin/sh

numb='588'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 20 --keyint 250 --lookahead-threads 4 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.2,2.8,0.4,0.6,0.6,0,1,8,20,250,4,24,30,5,0,69,38,3,2000,-2:-2,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"