#!/bin/sh

numb='2573'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 25 --keyint 260 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.0,1.3,4.0,0.2,0.9,0.3,1,0,10,25,260,4,24,40,4,4,65,28,3,2000,-2:-2,umh,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"