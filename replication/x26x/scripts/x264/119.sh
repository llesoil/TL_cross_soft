#!/bin/sh

numb='120'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 30 --keyint 260 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.6,1.0,1.8,0.2,0.8,0.6,1,2,8,30,260,4,30,0,4,4,69,28,3,2000,-1:-1,dia,crop,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"