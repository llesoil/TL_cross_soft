#!/bin/sh

numb='1089'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.5,1.2,1.8,0.6,0.7,0.3,3,2,16,5,230,2,26,40,4,2,65,28,1,2000,-1:-1,umh,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"