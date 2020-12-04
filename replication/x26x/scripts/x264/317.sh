#!/bin/sh

numb='318'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 230 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.3,1.4,0.6,0.6,0.5,3,0,10,40,230,2,26,20,4,4,62,28,5,1000,-2:-2,umh,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"