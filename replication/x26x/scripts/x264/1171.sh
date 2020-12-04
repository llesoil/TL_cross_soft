#!/bin/sh

numb='1172'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 15 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.3,1.3,4.4,0.4,0.7,0.3,2,2,2,15,290,1,28,10,5,4,69,18,1,2000,-2:-2,hex,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"